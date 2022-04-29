//
//  main.swift
//  tinkoffContest
//
//  Created by Егор Шкарин on 04.04.2022.
//

import Foundation

final class Cache<Key: Hashable, Value> {
    //Наш кеш
    private let wrapped = NSCache<WrappedKey, Entry>()
    // Замыкание, которое формирует дату при инициалицации кеша. По умолчанию текущая дата
    private let dateProvider: () -> Date
    // Интервал через которых кеш удаляется
    private let entryLifetime: TimeInterval
    
    init(dateProvider: @escaping () -> Date = Date.init,
         entryLifetime: TimeInterval = 12 * 60 * 60) {
        self.dateProvider = dateProvider
        self.entryLifetime = entryLifetime
    }
    
    /// Функция вставки значения в кеш
    /// - value - Значние
    /// - key - ключ
    func insert(_ value: Value, forKey key: Key) {
        // Добавляем временной интервал к дате, которую указали в инициализаторе
        let date = dateProvider().addingTimeInterval(entryLifetime)
        // Создаем значение для кеша
        let entry = Entry(value: value, expirationDate: date)
        // Кладем значение в кеш по задонному ключу Key
        wrapped.setObject(entry, forKey: WrappedKey(key))
    }
    
    /// Функция получения значения из кеша
    /// - key - ключ
    func value(forKey key: Key) -> Value? {
        // Получаем значение по ключу, если его нет возвращаем nil
        guard let entry = wrapped.object(forKey: WrappedKey(key)) else {
            return nil
        }
        // Сравниваем текущее время и время которе указано для значение
        // Если меньше то все ок, возвращаем значение, если больше то удаляем значение по ключу
        // и возвращаем nil
        guard dateProvider() < entry.expirationDate else {
            removeValue(forKey: key)
            return nil
        }
        return entry.value
    }
    /// Функция удаления значения из кеша
    /// - key - ключ
    func removeValue(forKey key: Key) {
        // Удаляем значение по ключу
        wrapped.removeObject(forKey: WrappedKey(key))
    }
}

private extension Cache {
    /// Класс для значний ключа в кеше
    // Наследуется от NSObject из за требований NSCache
    final class WrappedKey: NSObject {
        // Сам ключ, долже быть Hashable, так как он должен быть уникальным
        let key: Key
        
        init(_ key: Key) { self.key = key }
        
        override var hash: Int { return key.hashValue }
        // Эта перегрузка нудна чтобы мы могли сравнивать два значения по ключу
        override func isEqual(_ object: Any?) -> Bool {
            guard let value = object as? WrappedKey else {
                return false
            }
            return value.key == key
        }
    }
}

private extension Cache {
    /// Класс для значения в кеше.
    /// Хранить может что угодно
    final class Entry {
        let key: Key
        // Само значение
        let value: Value
        // Дата для удаление из кеша
        let expirationDate: Date
        
        init(value: Value, key: Key, expirationDate: Date) {
            self.key = key
            self.value = value
            self.expirationDate = expirationDate
        }
    }
}

extension Cache {
    /// Сабскрипт для обращению к кешу в виде: cache[key]
    /// и такого же получения из него данных
    subscript(key: Key) -> Value? {
        get { return value(forKey: key)}
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            self.insert(value, forKey: key)
        }
    }
}


